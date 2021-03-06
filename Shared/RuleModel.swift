// The RuleModel can be shared between all apps

import DirectToSwiftUI

let ruleModel : RuleModel = [
  // MARK: - Debug Mode
  // Enable this rule to show extra debug views in the UI.
  // \.platform == .phone => \.debug <= true,

  // MARK: - Authentication
  // Uncomment to enable the login panel.
  // Password: https://www.youtube.com/watch?v=a6iW-8xPw3k
  // \.firstTask <= "login",
  \.user?.username == "Mike" => \.visibleEntityNames <= [ "Actor", "Film" ],
  \.user?.username == "Mike" && \.object.firstName == "Penelope"
                             => \.isObjectEditable <= false,
  
  // just to avoid the not-null issue (note: Date is fixed here!)
  \.entity.name == "Film"
        => \.initialPropertyValues <= [ "fulltext": "", "lastUpdate": Date() ],
  
  
  // MARK: - Different Row Component
  // Just show the title of the Language object, instead of the summary.
  \.entity.name == "Language" && \.task == "select"
                    => \.rowComponent <= D2STitleText(),

  
  // MARK: - n:m Mapping Entities
  // `FilmActor is a n:m table. Instead of showing the mapping info, we show
  // the title of the film and the actors name.
  \.task == "list" && \.entity.name == "FilmActor"
       => \.displayPropertyKeys
       <= [ "film.title", "actor.firstName", "actor.lastName" ],
  // This is used to drop the key in the summary (just "Le me in" instead of
  // "Title: Let me in".
  \.propertyKey == "film.title"      => \.displayNameForProperty <= "",
  \.propertyKey == "actor.firstName" => \.displayNameForProperty <= "",
  \.propertyKey == "actor.lastName"  => \.displayNameForProperty <= "",


  // MARK: - ToOne Relationships
  // If the Customer list is shown, we just show the customers first name,
  // and his phone number (which is stored in the Address entity.
  // We also make sure to show "Phone" instead of "address.phone".
  \.task == "list" && \.entity.name == "Customer"
                => \.displayPropertyKeys <= [ "firstName", "address.phone" ],
  \.propertyKey == "address.phone"
                => \.displayNameForProperty <= "Phone",

  
  // MARK: - Custom Page View
  // An own `inspect` task page for `Customer` entities.
  // Check the CustomViews.swift for the implementation.
  \.platform == .phone && \.task == "inspect" && \.entity.name == "Customer"
    => \.page <= CustomerView(),
  
  
  // MARK: - Custom Formatters
  // We don't always need to replace a whole property view. Sometimes it is
  // sufficient to use a custom Formatter.
  // In here, we use a currency formatter for things like `rentalRate` and
  // different duration formatters.
  \.propertyKey == "rentalRate" || \.propertyKey == "replacementCost"
                                || \.propertyKey == "amount"
                                => \.formatter <= currencyFormatter,
  \.propertyKey == "rentalDuration" && \.task != "edit"
                                => \.formatter <= daysDurationFormatter,
  \.propertyKey == "length" && \.task != "edit"
                                => \.formatter <= minutesDurationFormatter,

  
  // MARK: - Multiline String Field
  // If we edit the movie description, we want a different property editor
  // component.
  \.propertyKey == "description" && \.task == "edit"
                                => \.component <= D2SEditLargeString(),
  
  
  // MARK: - Custom Property Editor
  // The movie rating is stored as a String, but we want to show our own
  // editor for that, which shows a Picker to select the rating.
  // Check the CustomViews.swift for the implementation.
  \.propertyKey == "rating" && \.task == "edit"
                                => \.component <= EditRating(),

  
  // MARK: - Rename Entity for Display
  // Instead of showing the "Actor" entity, let's display them properly as
  // "Moviestars"
  \.entity.name == "Actor" => \.displayNameForEntity <= "Moviestars",
  
  
  // MARK: - Configure which entities are visible to the user.
  // Only a few tables might be interesting to a user.
  // Note: see the login rules section, this can be different per user!
  \.visibleEntityNames <= [ "Customer", "Actor", "Film", "Store", "Staff" ],
  

  // MARK: - Email Field
  // On platforms which support it, show a clickable email for "email"
  // properties.
  \.task == "inspect" && \.propertyKey == "email"
                     => \.component <= D2SDisplayEmail(),
  
  
  // MARK: - Misc Customizations
  // We customize the "Rental" entity a little more.
  \.task == "list" && \.entity.name == "Rental"
     && \.object.d2s.isDefault == false
          => \.title <= \.object.rentalDate.string,
  \.task == "list" && \.entity.name == "Rental"
          => \.displayPropertyKeys <= [ "inventory.film.title", "returnDate" ],
  \.propertyKey == "inventory.film.title"
          => \.displayNameForProperty <= "Film",
  \.propertyKey == "inventory.film.title" && \.task == "list"
          => \.displayNameForProperty <= "",

  
  // MARK: - Int Bool Property
  // "active" is an Int based bool column in the database, we want to display
  // (and edit) that as a bool.
  \.entity.name == "Customer" && \.propertyKey == "active" && \.task == "edit"
                         => \.component <= D2SEditBool(),
  \.entity.name == "Customer" && \.propertyKey == "active"
                         => \.component <= D2SDisplayBool(),
]
