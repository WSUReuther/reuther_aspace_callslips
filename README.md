# Reuther ArchivesSpace Call Slips

This ArchivesSpace plugin adds an "Add Callslip" button to the staff interface Resource and Archival Object toolbars that generates a link to the Reuther's internal callslip database with various fields prefilled based on the originating record.

## Installation

Clone this repository to `/path/to/archivesspace/plugins` and enable the plugin by editing the `/path/to/archivesspace/config/config.rb`:

```
AppConfig[:plugins] = ['reuther_aspace_callslips']
```

The URL for the call slip database should be added to `/path/to/archivesspace/config/config.rb` as:

```
AppConfig[:call_slip_db] "http://db-url.reuther.wayne.edu"
```

## How it Works

This plugin includes the following components that together construct a URL that is opened in a new window to generate a new entry in the Reuther's call slip database.

### add_call_slip.js

The JavaScript file at `frontend/assets/add_call_slip.js` adds an "Add Callslip" button to Resource and Archival Object record toolbars. When clicked, the button makes a request to the `CallSlipsController` described below and then opens the link to the Reuther call slip database in a new window.

`add_call_slip.js` is added to Resource and Archival Object records by `frontend/views/layout_head.html.erb`

### CallSlipsController

The controller at `frontend/controllers/call_slips_controller.rb` includes a `generate` method which calls the `CallSlipGenerator` model described below and returns the result. 

The `generate` method is made available at `/plugins/call_slips/generate` by `frontend/routes.rb`

### CallSlipGenerator

The model at `frontend/models/call_slips.rb` queries the ArchivesSpace database for the following information and uses it to construct a URL for the Reuther's call slip database for requests made at any level:

- Resource title
- Resource ead_id
- Resource Physical Location note contents

When a request is made at the Archival Object level and that Archival Object also has a linked Top Container instance, the model also queries the database for the linked Top Container's indicator.
