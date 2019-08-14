def gallery_template
  {
    "messages": [
       {
         "attachment":{
           "type":"template",
           "payload":{
             "template_type":"generic",
             "image_aspect_ratio": "square",
             "elements": [
               {
                  title: 'test',
                  image_url: 'test',
                  subtitle: 'test',
                  buttons: [
                    {
                      type: 'test',
                      title: 'test',
                      url: 'test'
                    }
                  ]
              }
            ]
           }
         }
       }
     ]
  }
end