@ignore
Feature: Crear un usuario para usarlo en otras pruebas

  Scenario: Crear usuario
    * def usuario = call read('classpath:serverest/common/utils/data-generator.js')
    Given url baseUrl
    And path 'usuarios'
    And request usuario
    When method post
    Then status 201
    * def id = response._id
