#!/usr/bin/env ruby
require 'vault'
require 'base64'
TYPES = %w(file .env decode_base64).freeze
module Vault
  class Authenticate < Request
    def kubernetes(role, auth_path = nil,  token_path = nil)
      raise "Role cannot be nil" unless role
      auth_path ||= 'kubernetes'
      token_path ||= '/var/run/secrets/kubernetes.io/serviceaccount/token'

      path ||= File.join('/v1/auth', auth_path, 'login')

      payload = {
        role: role,
        jwt: File.read(token_path)
      }

      json = client.post(
        path,
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
