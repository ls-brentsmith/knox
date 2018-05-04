require 'vault'
TYPES = %w(file .env decode_base64).freeze
module Vault
  class Authenticate < Request
    def kubernetes(role, service_account_location = nil, route = nil)
      route ||= '/v1/auth/kubernetes/login'
      service_account_location ||=
        '/var/run/secrets/kubernetes.io/serviceaccount/token'

      payload = {
        role: role,
        jwt: File.read(service_account_location)
      }

      json = client.post(
        route,
        JSON.fast_generate(payload)
      )

      secret = Secret.decode(json)
      client.token = secret.auth.client_token

      return secret
    end
  end
end

def config
  @config ||= JSON.parse(File.read("config.json"))
end

def validate_type!(type)
  return if TYPES.include?(type)
  raise "Invalid type #{type}"
end

def to_env_file(metadata)
  env = metadata['data'].map {|k, v| "#{k}=#{v}"}
  File.write(metadata['output'], env.join("\n"))
end

def to_decode_base64(metadata)
  data = metadata['data']
  key = metadata['key']
  File.write(
    metadata['output'],
    Base64::decode64(data[key.to_sym])
  )
end

def to_file(metadata)
  data = metadata['data']
  key = metadata['key']
  File.write(metadata['output'], data[key.to_sym])
end

def read_secret(metadata)
  puts "Processing #{metadata['vault_secret_path']}"
  begin
  data = Vault.logical.read(
    metadata['vault_secret_path']
  ).data

  rescue Vault::HTTPClientError => e
    puts e.message
    raise "Unable to process #{metadata}"
  end

  data
end

def run
  Vault.auth.kubernetes(ENV['ROLE'])
  config.each do |metadata|
    validate_type!(metadata['type'])
    metadata['data'] = read_secret(metadata)

    case metadata['type']
    when '.env'
      to_env_file(metadata)
    when 'file'
      to_file(metadata)
    when 'decode_base64'
      to_decode_base64(metadata)
    end
  end
end

run
