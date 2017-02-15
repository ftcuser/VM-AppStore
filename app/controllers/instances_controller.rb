require 'aws-sdk'
require 'base64'
require 'openssl'

class InstancesController < ApplicationController

  # GET /instances
  # GET /instances.json
  def index
    @instances = Instance.find_by_ami('*')
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    @instance = Instance.find_by_id( params[:id] )
    @image = Image.find_by_ami(@instance.image_id)
  end

  def start
    Instance.start(params[:id])
    redirect_to :back
  end

  def stop
    Instance.stop(params[:id])

    redirect_to :back
  end

  def destroy
    Instance.terminate(params[:id])

    redirect_back(fallback_location: instances_path)

  end


end
