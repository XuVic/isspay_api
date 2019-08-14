def transaction_reply
  {
    messages: [
      { text: 'test',
        quick_replies: [
          {
            title: 'test',
            url: 'test',
            type: 'json_plugin_url'
          },
          {
            title: 'test',
            url: 'test',
            type: 'json_plugin_url'
          },
          {
            title: 'test',
            url: 'test',
            type: 'json_plugin_url'
          }
        ]
      },
    ]
  }
end