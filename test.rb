require 'aws-sdk'
require 'base64'
require 'openssl'

credentials = Aws::SharedCredentials.new(profile_name:'citizant')
client = Aws::EC2::Client.new(credentials: credentials,region: 'us-east-1')

resp = client.describe_instances({
  dry_run: false,
  filters: [
    {
      name: "tag:type",
      values: ["DemoInstance"],
    },
  ],
})

resp.reservations.each do |reservation|
  reservation.instances.each do |instance|
    puts "#{instance.instance_id} #{instance.image_id} #{instance.launch_time} #{instance.public_dns_name} #{instance.state.name}"
  end
end

# puts resp.inspect
