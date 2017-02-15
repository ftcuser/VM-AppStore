require 'aws-sdk'
require 'base64'
require 'openssl'

class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :launch, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # GET /images/1/launch
  def launch
    @image = Image.find(params[:id])

    credentials = Aws::SharedCredentials.new(profile_name:'citizant')
    client = Aws::EC2::Client.new(credentials: credentials,region: 'us-east-1')

    script = ''
    encoded_script = Base64.encode64(script)

    puts 'launching instance'
    resp = client.run_instances({
      # dry_run: true,
      image_id: @image.ami,
      min_count: 1,
      max_count: 1,
      key_name: 'testCluster',
      user_data: encoded_script,
      instance_type: 't1.micro',
      monitoring: {
        enabled: false, # required
      },
      placement: {
        availability_zone: 'us-east-1a'
      },
      network_interfaces: [{
        device_index: 0,
        groups: ['sg-e2fdcf9e'],
        associate_public_ip_address: true
      }]
    })
    instance_id = resp.instances[0].instance_id

    puts instance_id

    resp = client.create_tags({
      resources: [
        instance_id,
      ],
      tags: [
        {
          key: "Name",
          value: @image.name,
        },
        {
          key: "Description",
          value: @image.description,
        },
        {
          key: "type",
          value: "DemoInstance",
        }
      ],
    })

    puts "waiting for instance to initialize..."
    # Wait for the instance to be created, running, and passed status checks
    client.wait_until(:instance_running, {instance_ids: [instance_id]})

    respond_to do |format|
      format.html { redirect_to instance_path(instance_id) }
    end
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:name, :description, :ami, :os, :login)
    end
end
