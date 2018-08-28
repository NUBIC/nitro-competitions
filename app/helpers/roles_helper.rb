# -*- coding: utf-8 -*-

module RolesHelper
  include ApplicationHelper
  
  def is_admin?(program = current_program)
    return false unless session_exists?
    return true if current_user && current_user.system_admin?
    user_signed_in? && (!session[:act_as_admin].blank? || has_role('Admin', program))
  end

  def is_admin_any_program?
    return false unless session_exists?
    user_signed_in? && (!session[:act_as_admin].blank? || has_role_any_program('Admin'))
  end

  def has_read_all?(program = current_program)
    return false unless session_exists?
    user_signed_in? && (!session[:act_as_admin].blank? || has_role('Admin', program) || has_role('Full Read-only Access', program))
  end

  def is_super_admin?
    return false unless session_exists?
    user_signed_in? && current_user.system_admin?
    # user_signed_in? && !session[:act_as_admin].blank?
  end

  def has_role(role, program)
    return false unless user_signed_in?
    return false if current_user.blank?
    return false if current_user.roles_users.blank?
    current_user.roles_users.for_program(program.try(:id)).each do |user_role|
      return true if user_role.role.name == role
    end
    false
  end

  def has_role_any_program(role)
    return false unless user_signed_in?
    return false if current_user.blank?
    return false if current_user.roles_users.blank?
    current_user.roles_users.each do |user_role|
      return true if user_role.role.name == role
    end
    false
  end

  def session_exists?
    defined?(session) && ! session.nil?
  end
end
