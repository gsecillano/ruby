def bypass user_id = 'george.secillano@sap.com'
  a = ActiveRecord::AccessControl::UserContext.new(User.find_by_user_id(user_id))
  Thread.current[:active_record_access_control_context_stack] = [a]
end

def current_user
  ActiveRecord::AccessControl.current_context.current_user
end

bypass
