# This is an example of what can be added to a state file for integration into Slack
# Note, this only works in 2015.2 and above

slack-message:
   slack.post_message:
     - channel: '#se-demo'
     - from_name: SaltyCharles
     - message: 'This state was executed successfully for @SaltyCharles'
     - api_key: xoxp-2775848702-3925923278-4227790484-168d67

# salt '*' slack.post_message channel="se-demo" message="@SaltyCharles uses Salt to send another message to Slack. Woot Woot!" from_name="CharlesSaltAPI" api_key=xoxp-2775848702-3925923278-4227790484-168d67