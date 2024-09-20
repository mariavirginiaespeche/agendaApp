class WorkersController < ApplicationController
    def index
      @workers = Worker.all
    end
  
    def new
      @worker = Worker.new
    end
  
    def create
      @worker = Worker.new(worker_params)
      if @worker.save
        redirect_to workers_path, notice: 'Trabajador creado exitosamente.'
      else
        render :new
      end
    end
  
    private
  
    def worker_params
      params.require(:worker).permit(:name, :email)
    end
  end
  
