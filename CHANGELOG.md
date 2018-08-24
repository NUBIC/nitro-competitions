# NITRO Competitions Changelog
=======
## 5.1.3
Released August 24, 2018

# HOTFIX
Ensure submission max_project_cost is defined on validations.

=======
## 5.1.2
Released August 13, 2018

# BUGFIX
Implemented username downcasing.

=======
## 5.1.1
Released August 9, 2018

# GEMS
* Add chromedriver-helper gem.

# UI
* Add Initiated Studies to the welcome page.

=======
## 5.1
Released July 2, 2018

# SYSTEM
* Update to Rails 5.2, including config changes.
* Remove dynamic routing.

# GEMS
* Add Puma gem.
* Change FactoryGirl to FactoryBot.

# NEW RAKE TASKS
* Find emails by role.
* Find and merge duplicate users.

# UI
* Add Require Effort Approver option.
* Fix footer transparency.

# PROJECTS
* Change scoping class methods to scopes.
* Add Project scopes: published, with_program, with_submissions.
* Clear duplicated project rfa_url when it links to orig project.
* Add simplified public project list view.

# SUBMISSIONS
* Add require_biosketch check.

# MISCELLANEOUS
* Purge unused methods.

=======
## 5.0
Released May 18, 2018

# SYSTEM
* Update to ruby 2.5.
* Update to rails 5.1.5.

# GEMS
* Add faker gem.
* Remove all remnants of searchlight.

# DEBUGGING
* Add completion_score validation.
* Include completion_score in review composite scores calculations.
* change @@projects to instance variable.
* Fix and update google_oauth2 authentication.

# UI
* Improve page title handling.
* Convert all .haml templates to .erb.
* Standardize text_field and text_area field widths for project form and submission form.
* Improve text_field and text_area validations for project form and submission form.
* Limit footer contact information to project- and submission-related actions.
* Update links to new NUCATS membership URL.
* Improve submission sorting exclusion on Files columns.

# SCORING
* Add with_scoring concern used in project, submission and submission_review models.
* Update submission composite scoring calculation.
  * Individual review composite is an average of the review's scored criteria.
  * Overall submission composite is an average of all reviews' scored criteria.

# PROJECTS
* Remove project duplication logic from project#new.
* Create service object for project duplication and add project/duplicate controller.
* Add "Supporting Documents and Links" section to project display.
* Add admin  "Manage this comptetition" section for admin links.
  * Add "Use this competition as a template" link to dupliate compeition.

# SUBMISSIONS
* Add applicant to the submission#update method.
* Add default text for submission files.
* Check is_admin? once per submission for submission review table.
* Standardize the order of scores in submission_review model.
* Add submission_category to submission_controller.


## For prior release information please see commit history
## at https://github.com/NUBIC/nitro-competitions.
