ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    # Here is an example of a simple dashboard with columns and panels.

    columns do
      column do
        panel "Recent Grants" do
          ul do
            Grant.last(10).map do |grant|
              li link_to(grant.title, grant.status, admin_grant_path(grant))
            end
          end
        end
      end

      column do
        panel "Recent Users" do
          ul do
            User.last(10).map do |user|
              li link_to(user.first_name, user.last_name, admin_user_path(user))
            end
          end
        end
      end

      column do
        panel "Recent Payments" do
          ul do
            Payment.last(10).map do |payment|
              li link_to(payment.user.first_name, payment.user.last_name, payment.grant.title, admin_payment_path(payment))
            end
          end
        end
      end

    end
  end # content
end
