Rails.application.routes.draw do
  get("/", :controller => "application", :action => "question")
  get("/answer", :controller => "application", :action => "answer")
end
