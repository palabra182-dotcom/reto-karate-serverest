Feature: DELETE /usuarios/{_id} - Eliminar usuario

  Background:
    * url baseUrl

  Scenario: Eliminar un usuario existente
    * def nuevo = call read('classpath:serverest/common/helpers/crear-usuario.feature')

    Given path 'usuarios', nuevo.id
    When method delete
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    Given path 'usuarios', nuevo.id
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  Scenario: Eliminar un ID que no existe
    Given path 'usuarios', 'idNoExiste123456'
    When method delete
    Then status 200
    And match response.message == 'Nenhum registro excluído'
