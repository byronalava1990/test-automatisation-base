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

  @consultarPeronsajeMarvelPorId
  Scenario: T-API-BMO-9876 - Obtener personaje marvel por ID
    * header content-type = 'application/json'
    Given url urlMarvel + '/14'
    When method GET
    Then status 200
    And match response.name == '#regex (?i).*spider-man.*'

