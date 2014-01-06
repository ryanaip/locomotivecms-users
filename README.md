# TODO

* ~~Add ability to login/logout with `Locomotive::ContentType` models that have `_user` set to true.~~
* ~~Expose flash messages to templates~~
* ~~Expose logged in user in templates~~
* Add tests for flash messages and template views
* Add ability to specify user access to page templates
* Require that user-enabled content types have an email field that is required.
* Add a toggle option for setting a content type to be user-enabled.
* Show all fields in the sign up form (plus password)
* Clean up route helpers
* Logout other users when you login as a new user
* Remove manual creation of warden mappings in after save of `ContentEntry`
