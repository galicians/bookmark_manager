

def send_simple_message
  RestClient.post "https://api:key-33a2cd86325d425d00a4b09b01972f81"\
  "@api.mailgun.net/v2/sandbox2d47f81ef7ae4792b875cab58f8a954b.mailgun.org/messages",
  :from => "Mailgun Sandbox <postmaster@sandbox2d47f81ef7ae4792b875cab58f8a954b.mailgun.org>",
  :to => "Pablo Portabales <galicians@gmail.com>",
  :subject => "Hello Pablo Portabales",
  :text => "Hi Pablo, you just sent an email with Mailgun!  You can see a record of this email in your logs: https://mailgun.com/cp/log .  You can send up to 300 emails/day from this sandbox server.  Next, you should add your own domain so you can send 10,000 emails/month for free."
end
    