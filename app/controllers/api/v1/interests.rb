module API
  module V1
    class Interests < Grape::API
      include API::V1::Defaults
      helpers UpdateInterests

      resource :interests do

        ############################
        # => CREATE
        #    new interest
        ############################

        desc 'Create a new interest for the current user.'
        oauth2
        params do
          requires :data, type: Hash do
            requires :offer, type: String, values: ["offer", "search"]
            requires :target, type: String, values: ["Klinik", "Institut", "Firma", "Student", "Any"]
            requires :category, type: String, values: ["Hospital IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0"]
            requires :subcategory, type: String, values: ["Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"]
            requires :typus, type: String, values: ["FE+E-Projektkooperation", "FE+E-Auftragszusammenarbeit", "Bachelor/Masterarbeit", "Praktikum"]
            requires :keywords, type: Array
            requires :title, type: String, allow_blank: false
            requires :description, allow_blank: false
            optional :attachment, type: Rack::Multipart::UploadedFile
          end
        end
        post '/' do
          create_new_interest(params)
        end

        desc 'Create a new interest for a selected user (admin only).'
        oauth2
        params do
          requires :data, type: Hash do
            requires :user_id, type: Integer
            requires :offer, type: String, values: ["offer", "search"]
            requires :target, type: String, values: ["Klinik", "Institut", "Firma", "Student", "Any"]
            requires :category, type: String, values: ["Hospital IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0", "Beliebig"]
            requires :subcategory, type: String, values: ["Beliebig", "Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"]
            requires :typus, type: String, values: ["FE+E-Projektkooperation", "FE+E-Auftragszusammenarbeit", "Bachelor/Masterarbeit", "Praktikum"]
            optional :keywords, type: Array, allow_blank: true
            requires :title, type: String, allow_blank: false
            requires :description, allow_blank: false
            optional :attachment, type: Rack::Multipart::UploadedFile
          end
        end
        post '/create' do
          assign_interest(params)
        end

        ############################
        # => READ
        #    get interests
        #    get interest
        ############################

        desc 'Return all interests'
        oauth2
        get '/' do
          get_all(params)
        end

        desc 'Return all interests of category'
        params do
          requires :category, type: String
        end
        get '/category' do
          get_by_category(params)
        end

        desc 'Return most used keywords'
        get '/keywords' do
          get_most_keywords()
        end

        desc 'Return one interest'
        oauth2
        params do
          requires :id, type: Integer
        end
        get '/:id' do
          get_one(params)
        end

        desc 'Get Contact Data'
        oauth2
        params do
          requires :id, type: Integer
        end
        get '/contact/:id' do
          make_contact(params)
        end

        ############################
        # => UPDATE
        #    edit interest
        ############################

        desc 'Edit an existing interest'
        oauth2
        params do
          requires :data, type: Hash do
            requires :id, type: Integer
            optional :offer, type: String, values: ["offer", "search"]
            optional :target, type: String, values: ["Klinik", "Institut", "Firma", "Student", "Any"]
            optional :category, type: String, values: ["Hospital IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0"]
            optional :subcategory, type: String, values: ["Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"]
            optional :typus, type: String, values: ["FE+E-Projektkooperation", "FE+E-Auftragszusammenarbeit", "Bachelor/Masterarbeit", "Praktikum"]
            optional :keywords, type: Array
            optional :title, type: String, allow_blank: false
            optional :description, allow_blank: false
            optional :attachment, type: Rack::Multipart::UploadedFile
          end
        end
        put '/' do
          edit_interest(params)
        end

        ############################
        # => DESTROY
        #    delete interest
        ############################

        desc 'Remove an existing interest'
        oauth2
        delete '/:id' do
          remove_interest(params)
        end
      end
    end
  end
end