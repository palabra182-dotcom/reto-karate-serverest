@ignore
Feature: Eliminar un usuario creado en las pruebas

  Scenario: Eliminar usuario
    Given url baseUrl
    And path 'usuarios', id
    When method delete
    Then status 200
