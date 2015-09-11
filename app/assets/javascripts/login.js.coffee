jQuery ->
  jQuery('input[name="organization"]').change ->
    jQuery('.domain_options').hide()
    value = jQuery('input[name="organization"]:checked').val()
    if value.length > 0
      jQuery("#username_#{value}").show()

  jQuery('#login_fields input').change ->
    domain   = jQuery('#domain').val()
    username = jQuery('#username').val()
    password = jQuery('#password').val()
    if(domain.length > 0 && username.length > 0)
      jQuery('input[type="submit"]').prop({disabled: false})
      jQuery('input[type="submit"]').removeClass('disabled_button')
      jQuery('input[type="submit"]').addClass('enabled_button')

  jQuery('#username_nu.domain_options .domain_option').click ->
    jQuery('#username_nu.domain_options a.domain_option.selected_domain').each () ->
      jQuery(this).removeClass('selected_domain')
    jQuery('#username_nu.domain_options a.domain_option.selected_domain').each () ->
      jQuery(this).removeClass('selected_domain')
    jQuery(this).addClass('selected_domain')
    jQuery("#domain_view").text(jQuery(this).attr('title'))
    jQuery("#domain").val(jQuery(this).attr('id'))
    set_username_placeholder_text(jQuery(this).attr('id'));

  set_username_placeholder_text = (id) ->
    value = 'Username: '
    switch id
      when 'nu' then value = 'NU NetID'
      when 'nmh' then value = 'NMH Windows Username'
      when 'nmff-net' then value = 'NMFF Windows Username'
      when 'ric' then value = 'RIC Username'
      when 'lurie_childrens' then value = 'Lurie Username'
    jQuery("#username").prop({placeholder: value})
