$ ->
  $('input[name="organization"]').change ->
    $('div.domain_options').hide()
    value = $('input[name="organization"]:checked').val()
    if value.length > 0
      $("#username_#{value}").show()

  $('#login_fields input').change ->
    domain   = $('#domain').val()
    username = $('#username').val()
    password = $('#password').val()
    if(domain.length > 0 && username.length > 0)
      $('input[type="submit"]').prop({disabled: false})
      $('input[type="submit"]').removeClass('disabled_button')
      $('input[type="submit"]').addClass('enabled_button')

  $('#username_nu.domain_options .domain_option').click ->
    $('#username_nu.domain_options span.domain_option.selected_domain').each () ->
      $(this).removeClass('selected_domain')
    $('#username_nu.domain_options a.domain_option.selected_domain').each () ->
      $(this).removeClass('selected_domain')
    $(this).addClass('selected_domain')
    $("#domain_view").text($(this).attr('title'))
    $("#domain").val($(this).attr('id'))
    set_username_placeholder_text($(this).attr('id'));

  set_username_placeholder_text = (id) ->
    value = 'Username: '
    switch id
      when 'nu' then value = 'NU NetID'
      when 'nmh' then value = 'NMH Windows Username'
      when 'nmff-net' then value = 'NMFF Windows Username'
      when 'ric' then value = 'RIC Username'
      when 'lurie_childrens' then value = 'Lurie Username'
    $("#username").prop({placeholder: value})
