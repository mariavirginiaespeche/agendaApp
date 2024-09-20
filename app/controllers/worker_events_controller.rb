class WorkerEventsController < ApplicationController
    def index
      @worker = Worker.find(params[:worker_id])
      @events = @worker.events
    end
  end
  