# app/controllers/welcome_controller.rb

class WelcomeController < ApplicationController
    def index
        render html: "<h1>Jillian's Viewing Party API Project</h1>".html_safe
    end
end
