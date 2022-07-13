**This project is no longer maintained and we have migrated to using a new version of Competitions.**
https://github.com/NUARIG/competitions
_____________________________________________________________________________________________________



**NITRO**Competitions is a web-based application for managing institutional funding
competitions.

## Main features

* Create a competition framework
* Publish the competition and associated details
* Ability for faculty and staff to authenticate to **NITRO**Competitions using any OAuth
  provider via the [`omniauth` gem][1]
* Submission of proposals
* A workflow for reviewing submissions via one or more members of a review panel
* Email notifications of submission and review progress

The review criteria and panel setup mirrors the NIH study panel design by
default.

## About

**NITRO**Competitions is written in [Ruby on Rails 5][2] and uses [PostgreSQL][3] as the
backend database by default. However, any RDBMS that is supported by
[ActiveRecord][4] should work.

## Data model

**NITRO**Competitions has the following major models to organize sponsoring
organizations, competitions, reviewers, submitters, applicants, and reviews:

1. **Sponsor**: A sponsoring organization running a competition
2. **Competition**: A competition to be managed
3. **User**: An individual who logs in, or is listed with a role, is in the
  `users` table. Users can have one or more of the following roles:
  * administrator
  * reviewer
  * key person
  * applicant
4. **Submission**: Submissions have the following:
  * submitter
  * applicant (the submitter and applicant can be the same)
  * key personnel
  * documents
  * a cover page
  * assigned reviewers (assigned by the administrators of the sponsoring
    organization for the competition)
5. **Review**:  Reviews, by default, follow the NIH review criteria, and consist
  of these review categories:
  * Overall
  * Significance
  * Investigators
  * Innovation
  * Approach
  * Environment

The categories can be customized on a per-competition basis. A 1-9 score, and
descriptive text can be entered for each criterion.

## Installing NITROCompetitions

Since **NITRO**Competitions is a standard Rails app, installing it is just like
installing any other Rails app. The current version of the code is tested
against Ruby 2.5

See the [wiki][8] for install instructions.

## Running the test suite

**NITRO**Competitions has a number of rspec tests. To run these specs run the following
command in the project folder:

    $ bundle exec rspec

## Authentication

### OAuth

The current version of **NITRO**Competitions uses OAuth providers for authentication,
via the [`omniauth` gem][1].

See [`config/application.rb line 58`][6]

If you DO use an OAuth provider, note that you must register this application as
a client of that provider (e.g. register the app with Google, Facebook, or
whoever your OAuth provider is). Details on how to do that are
provider-specific, and the provider's documentation should be consulted in those
cases.

## Contributing

### Feedback and bug/issue reports

We welcome new ideas and perspectives on the app's usage that have not been
considered before. If you have an idea feel free to
[let us know](mailto:competitions@northwestern.edu).

Currently we host our issue and bug tracking system internally. However, if
you'd like to submit a github issue, we'll take a look at it and get back to
you.

If you want to report a security problem that you feel should be reported
privately first, you can email
[competitions@northwestern.edu](mailto:competitions@northwestern.edu).

### Code contributions

Please see the [code contribution guide][7] for more details.

  [1]: https://github.com/intridea/omniauth/wiki/List-of-Strategies
  [2]: http://rubyonrails.org/
  [3]: http://www.postgresql.org/
  [4]: http://guides.rubyonrails.org/active_record_querying.html
  [5]: https://github.com/NUBIC/aker
  [6]: https://github.com/NUBIC/nitro-competitions/blob/v2.2.9/config/application.rb#L58
  [7]: https://github.com/NUBIC/nitro-competitions/wiki/Contributing-code
  [8]: https://github.com/NUBIC/nitro-competitions/wiki
