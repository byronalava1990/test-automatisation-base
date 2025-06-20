@idMarvel
Feature: Pruebas automatizadas para la API Marvel Characters -balava

  Background:
    * def urlMarvel = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * configure ssl = true

  @consultarTodosPersonajesMarvel
  Scenario: T-API-BMO-9876 - Obtener todos los personajes de marvel
    * header content-type = 'application/json'
    Given url urlMarvel
    When method GET
    Then status 200
    And match response == '#[]'

  @crearNuevoPersonajeMarvel
  Scenario: T-API-BMO-9877- Crear un nuevo personaje de marvel
    * header content-type = 'application/json'
    * def randomNumber = Math.floor(Math.random() * 10000)
    * def uniqueName = 'Iron Man Superior-' + randomNumber + '-' + java.time.LocalTime.now().format(java.time.format.DateTimeFormatter.ofPattern('HHmmss'))
    * def requestPayload = { "name": '#(uniqueName)', "alterego": "Tony Stark", "description": "Genio, millonario, playboy, filántropo", "powers": ["Armadura", "Inteligencia"] }
    Given url urlMarvel
    And request requestPayload
    When method POST
    Then status 201
    And match response.id == '#notnull'
    * def createdId = response.id

  @consultarPeronsajeMarvelPorId
  Scenario: T-API-BMO-9876 - Obtener personaje marvel por ID
    * header content-type = 'application/json'
    * def result = callonce read('karate-test.feature@crearNuevoPersonajeMarvel')
    * def createdId = result.createdId
    Given url urlMarvel + '/' + createdId
    When method GET
    Then status 200
    And match response.name == '#regex (?i).*Iron Man Superior.*'

  @actualizarPersonajeMarvel
  Scenario: T-API-BMO-9878- Actualizar un personaje existente de marvel
    * header content-type = 'application/json'
    * def result = callonce read('karate-test.feature@crearNuevoPersonajeMarvel')
    * def createdId = result.createdId
    Given url urlMarvel + '/' + createdId
    And request { "name": "Iron Man Actualizado", "alterego": "Tony Stark", "description": "Superhéroe actualizado", "powers": ["Armadura avanzada", "Inteligencia superior"] }
    When method PUT
    Then status 200
    And match response.description == 'Superhéroe actualizado'

  @eliminarPersonajeMarvel
  Scenario: T-API-BMO-9879- Eliminar el personaje creado previamente
    * header content-type = 'application/json'
    * def result = callonce read('karate-test.feature@crearNuevoPersonajeMarvel')
    * def createdId = result.createdId
    Given url urlMarvel + '/' + createdId
    When method DELETE
    Then status 204