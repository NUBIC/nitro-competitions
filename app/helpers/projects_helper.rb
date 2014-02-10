# -*- coding: utf-8 -*-

module ProjectsHelper

  def project_status
    return if current_projects.nil?
    s = ''
    current_projects.each do |project|
      unless project.submission_close_date.nil?
        s << ns { project_will_start(project.submission_open_date, project.project_title + ' submission') }
        s << ns { project_is_ongoing(project.submission_open_date, project.submission_close_date, project.project_title + ' submission') }
        s << ns { project_recently_closed(project.submission_close_date, project.project_title + ' submission') }
      end
      unless project.review_end_date.nil?
        s << ns { project_will_start(project.review_start_date, project.project_title + ' review ') }
        s << ns { project_is_ongoing(project.review_start_date, project.review_end_date, project.project_title + ' review ') }
        s << ns { project_recently_closed(project.review_end_date, project.project_title + ' review ') }
      end
      # pulled this for now. email from Jim Bray 2/19/2010
      unless true || project.project_period_start_date.nil?
        s << ns { project_will_start(project.project_period_start_date, project.project_title + ' Project Period ') }
        s << ns { project_is_ongoing(project.project_period_start_date, project.project_period_end_date, project.project_title + ' Project Period ') }
        s << ns { project_recently_closed(project.project_period_end_date, project.project_title + ' Project Period ') }
      end
    end
    s
  end

  def project_will_start(start_date, phrase)
    if Time.now < start_date && Time.now + 90.days > start_date
      proj_heading(phrase + ' process  will open in ' +
                   distance_of_time_in_words(Time.now, start_date) + '.')
    end
  end

  def project_is_ongoing(start_date, end_date, phrase)
    if Time.now + 1.day > start_date && Time.now - 1.day < end_date
      proj_heading(phrase + ' process is ongoing. The process started ' +
                   distance_of_time_in_words(Time.now, start_date) +
                   ' ago and will close in ' +
                   distance_of_time_in_words(Time.now, end_date) + '.')
    end
  end

  def project_recently_closed(end_date, phrase)
    if Time.now > end_date && Time.now < end_date + 21.days
      proj_heading(phrase + ' process was closed ' +
                   distance_of_time_in_words(Time.now, end_date) + ' ago.')
    end
  end

  def ns
    s = yield
    return '' if s.nil?
    s
  end

  def proj_heading(phrase)
    %{
        <h3>
          #{phrase}
        </h3>
    }
  end
end
