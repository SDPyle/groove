defmodule Groove.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  actions do
    defaults [:read]
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    api Groove.Accounts

    add_ons do
      confirmation :confirm do
        monitor_fields([:email])
        sender(Groove.Accounts.Senders.SendEmailConfirmationEmail)
      end
    end

    strategies do
      password :password do
        identity_field(:email)
        sign_in_tokens_enabled?(true)

        resettable do
          sender(Groove.Accounts.Senders.SendPasswordResetEmail)
        end
      end
    end

    tokens do
      enabled?(true)
      token_resource(Groove.Accounts.Token)

      signing_secret(Groove.Accounts.Secrets)
    end
  end

  postgres do
    table "users"
    repo Groove.Repo
  end

  identities do
    identity :unique_email, [:email] do
      eager_check_with Groove.Accounts
    end
  end

  validations do
    validate match(:email, ~r/^[^\s]+@[^\s]+$/), on: [:create, :update], message: "invalid email"
  end

  relationships do
    has_one :profile, Groove.Profiles.Profile do
      source_attribute :id
      destination_attribute :id
    end
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
