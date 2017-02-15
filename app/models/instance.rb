require 'aws-sdk'
require 'base64'
require 'openssl'


class Instance
  @@credentials = Aws::SharedCredentials.new(profile_name:'citizant')
  @@client = Aws::EC2::Client.new(credentials: @@credentials,region: 'us-east-1')

  def self.find_by_id(id)
    #get data on instances
    resp = @@client.describe_instances({
      dry_run: false,
      instance_ids: [ id ]
    })
    resp.reservations[0].instances[0]
  end

  def self.find_by_ami(ami)
    #get data on instances
    resp = @@client.describe_instances({
      dry_run: false,
      filters: [
        {
          name: "tag:type",
          values: ["DemoInstance"],
        },
        {
          name: "image-id",
          values: [ami],
        },
      ],
    })
    instances = []
    resp.reservations.each do |res|
      res.instances.each do |instance|
        instances << instance
      end
    end

    instances
  end

  def self.start(id)
    @@client.start_instances({
      instance_ids: [id]
    })
  end

  def self.stop(id)
    @@client.stop_instances({
      instance_ids: [id]
    })
  end

  def self.terminate(id)
    @@client.terminate_instances({
      instance_ids: [id]
    })
  end

  def persisted?
    false
  end

end
