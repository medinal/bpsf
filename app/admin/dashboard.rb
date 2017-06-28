ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    # Here is an example of a simple dashboard with columns and panels.

    columns do

      column do
        panel "Recent Grants" do
          table_for Grant.order('id desc').limit(10) do
            column("Title") {|grant| link_to(grant.title, admin_grant_path(grant))}
            column("Status") {|grant| status_tag(grant.status)}
            column("Teacher") {|grant| grant.user}
            column("Deadline") {|grant| grant.deadline}
          end
        end
      end

      column do
        panel "Recent Users" do
          table_for User.order('id desc').limit(10) do
            column("Name") {|user| link_to(user.full_name, admin_user_path(user))}
            column("Role") {|user| user.role}
            column("E-Mail") {|user| user.email}
          end
        end
      end

      column do
        panel "Recent Payments" do
          table_for Payment.order('id desc').limit(10) do
            column("Grant") {|payment| link_to(payment.grant.title, admin_grant_path(payment.grant))}
            column("User") {|payment| link_to("#{payment.user.first_name} #{payment.user.last_name}", admin_user_path(payment.user))}
            column("Amount") {|payment| payment.amount}
            column("Status") {|payment| status_tag(payment.status)}
          end
        end
      end

    end
  end # content
end
