# -*- coding: utf-8 -*-
module ReviewersHelper

  def review_item_observer(field_name, id)
    observe_field('submission_review_' + field_name,
                  frequency: 2.0,
                  before: "Element.show('spinner')",
                  complete: "Element.hide('spinner')",
                  url: update_review_item_path(id),
                  with: "'submission_review[" + field_name.to_s + "]=' + encodeURIComponent(value)")
  end

end
