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
            requires :offer, type: String, values: {value: ["offer", "search"], message: "offer:Ungültiger Wert"}, message: "offer:Art des Profils fehlt."
            requires :target, type: String, values: {value: ["Klinik", "Institut", "Firma", "Student"], message: "target:Ungültiger Wert"}, message: "target:Zielperson des Profils fehlt."
            requires :category, type: String, values: {value: ["Beliebig","Hospital IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0"], message:"category:Ungültiger Wert"}, message: "category:Kategorie fehlt."
            requires :subcategory, type: String, values: {value: ["Beliebig","Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"], message: "subcategory:Ungültiger Wert"}, message: "subcategory:Unterkategorie fehlt."
            requires :typus, type: String, values: {value: ["FE+E-Projektkooperation", "FE+E-Auftragszusammenarbeit", "Bachelor/Masterarbeit", "Praktikum"], message: "typus:Profiltyp ungültig."}, message: "typus:Profiltyp fehlt."
            optional :keywords, type: Array
            requires :title, type: String, allow_blank: {value: false, message:"title:Der Profiltitel darf nicht leer sein."}, message: "title:Der Profiltitel fehlt."
            requires :description, allow_blank: {value: false, message: "description:Die Profilbeschreibung darf nicht leer sein."}, message: "description:Die Profilbeschreibung fehlt."
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
            requires :user_id, type: Integer, message: "user_id:Die zugehörige Account-ID fehlt."
            requires :offer, type: String, values: {value: ["offer", "search"], message: "offer:Ungültiger Wert"}, message: "offer:Art des Profils fehlt."
            requires :target, type: String, values: {value: ["Klinik", "Institut", "Firma", "Student"], message: "target:Ungültiger Wert"}, message: "target:Zielperson des Profils fehlt."
            requires :category, type: String, values: {value: ["Beliebig","Hospital IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0"], message:"category:Ungültiger Wert"}, message: "category:Kategorie fehlt."
            requires :subcategory, type: String, values: {value: ["Beliebig","Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"], message: "subcategory:Ungültiger Wert"}, message: "subcategory:Unterkategorie fehlt."
            requires :typus, type: String, values: {value: ["FE+E-Projektkooperation", "FE+E-Auftragszusammenarbeit", "Bachelor/Masterarbeit", "Praktikum"], message: "typus:Profiltyp ungültig."}, message: "typus:Profiltyp fehlt."
            optional :keywords, type: Array
            requires :title, type: String, allow_blank: {value: false, message:"title:Der Profiltitel darf nicht leer sein."}, message: "title:Der Profiltitel fehlt."
            requires :description, allow_blank: {value: false, message: "description:Die Profilbeschreibung darf nicht leer sein."}, message: "description:Die Profilbeschreibung fehlt."
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

        desc 'Return 2 semi-random interests'
        get '/target' do
          get_semi_random_interest()
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
            optional :offer, type: String, values: {value: ["offer", "search"], message: "offer:Ungültiger Wert"}
            optional :target, type: String, values: {value: ["Klinik", "Institut", "Firma", "Student"], message: "target:Ungültiger Wert"}
            optional :category, type: String, values: {value: ["Beliebig","Hospital IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0"], message:"category:Ungültiger Wert"}
            optional :subcategory, type: String, values: {value: ["Beliebig","Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"], message: "subcategory:Ungültiger Wert"}
            optional :typus, type: String, values: {value: ["FE+E-Projektkooperation", "FE+E-Auftragszusammenarbeit", "Bachelor/Masterarbeit", "Praktikum"], message: "typus:Profiltyp ungültig."}
            optional :keywords, type: Array
            optional :title, type: String, allow_blank: {value: false, message:"title:Der Profiltitel darf nicht leer sein."}
            optional :description, allow_blank: {value: false, message: "description:Die Profilbeschreibung darf nicht leer sein."}
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