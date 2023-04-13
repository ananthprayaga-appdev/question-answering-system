class ApplicationController < ActionController::Base
  def question
    @patient = { :id => 3445, :first_name => "Cynthia", :last_name => "Jones", :description => " A lady was admitted to the hospital with chest pain and respiratory insufficiency.  She has chronic lung disease with bronchospastic angina.", :medical_specialty => " General Medicine", :sample_name => " Chest Pain & Respiratory Insufficiency ", :transcription => "We discovered new T-wave abnormalities on her EKG.  There was of course a four-vessel bypass surgery in 2001.  We did a coronary angiogram.  This demonstrated patent vein grafts and patent internal mammary vessel and so there was no obvious new disease.,She may continue in the future to have angina and she will have nitroglycerin available for that if needed.,Her blood pressure has been elevated and so instead of metoprolol, we have started her on Coreg 6.25 mg b.i.d.  This should be increased up to 25 mg b.i.d. as preferred antihypertensive in this lady's case.  She also is on an ACE inhibitor.,So her discharge meds are as follows:,1.  Coreg 6.25 mg b.i.d.,2.  Simvastatin 40 mg nightly.,3.  Lisinopril 5 mg b.i.d.,4.  Protonix 40 mg a.m.,5.  Aspirin 160 mg a day.,6.  Lasix 20 mg b.i.d.,7.  Spiriva puff daily.,8.  Albuterol p.r.n. q.i.d.,9.  Advair 500/50 puff b.i.d.,10.  Xopenex q.i.d. and p.r.n.,I will see her in a month to six weeks.  She is to follow up with Dr. X before that.", :keywords => ["general medicine", "chest pain", "respiratory insufficiency", "chronic lung disease", "bronchospastic angina", "insufficiency", "chest", "angina", "respiratory", "bronchospastic"] }

    render({ :template => "main/homepage.html.erb" })
  end

  def answer
    @patient = { :id => 3445, :first_name => "Cynthia", :last_name => "Jones", :description => " A lady was admitted to the hospital with chest pain and respiratory insufficiency.  She has chronic lung disease with bronchospastic angina.", :medical_specialty => " General Medicine", :sample_name => " Chest Pain & Respiratory Insufficiency ", :transcription => "We discovered new T-wave abnormalities on her EKG.  There was of course a four-vessel bypass surgery in 2001.  We did a coronary angiogram.  This demonstrated patent vein grafts and patent internal mammary vessel and so there was no obvious new disease.,She may continue in the future to have angina and she will have nitroglycerin available for that if needed.,Her blood pressure has been elevated and so instead of metoprolol, we have started her on Coreg 6.25 mg b.i.d.  This should be increased up to 25 mg b.i.d. as preferred antihypertensive in this lady's case.  She also is on an ACE inhibitor.,So her discharge meds are as follows:,1.  Coreg 6.25 mg b.i.d.,2.  Simvastatin 40 mg nightly.,3.  Lisinopril 5 mg b.i.d.,4.  Protonix 40 mg a.m.,5.  Aspirin 160 mg a day.,6.  Lasix 20 mg b.i.d.,7.  Spiriva puff daily.,8.  Albuterol p.r.n. q.i.d.,9.  Advair 500/50 puff b.i.d.,10.  Xopenex q.i.d. and p.r.n.,I will see her in a month to six weeks.  She is to follow up with Dr. X before that.", :keywords => ["general medicine", "chest pain", "respiratory insufficiency", "chronic lung disease", "bronchospastic angina", "insufficiency", "chest", "angina", "respiratory", "bronchospastic"] }

    request_content = "#{@patient.fetch(:description)} The patient name is #{@patient.fetch(:first_name)} #{@patient.fetch(:last_name)}. Visit reason: #{@patient.fetch(:sample_name)}. The notes during the visit are: #{@patient.fetch(:transcription)}"

    question = params.fetch("question")

    @display_question = question

    $LOAD_PATH << "."
    require "openai"

    openai_client = OpenAI::Client.new(
      access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"),
      request_timeout: 240, # Optional parameter; increases the number of seconds before a request times out
    )

    response = openai_client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required. I recommend using gpt-3.5-turbo while developing, because it's a LOT cheaper than gpt-4
        messages: [
          { role: "system", content: request_content + "You are a helpful assistant and answer questions to the point." },
          { role: "user", content: question },
        ],
        temperature: 0.7,
      },
    )

    @message_response = response.fetch("choices").at(0).fetch("message").fetch("content")

    render({ :template => "main/answerpage.html.erb" })
  end
end
