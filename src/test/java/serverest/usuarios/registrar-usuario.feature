Feature: POST /usuarios - Registrar usuario

  Background:
    * url baseUrl
    * def usuario = call read('classpath:serverest/common/utils/data-generator.js')

  Scenario Outline: Registrar un usuario con administrador <administrador>
    * set usuario.administrador = '<administrador>'

    Given path 'usuarios'
    And request usuario
    When method post
    Then status 201
    And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(response._id)' }

    Examples:
      | administrador |
      | true          |
      | false         |

  Scenario: No se puede registrar un usuario con un email que ya existe
    * def existente = call read('classpath:serverest/common/helpers/crear-usuario.feature')
    * set usuario.email = existente.usuario.email

    Given path 'usuarios'
    And request usuario
    When method post
    Then status 400
    And match response.message == 'Este email já está sendo usado'

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(existente.id)' }

  Scenario Outline: No se puede registrar un usuario sin <campo>
    * remove usuario.<campo>

    Given path 'usuarios'
    And request usuario
    When method post
    Then status 400
    And match response.<campo> == '<campo> é obrigatório'

    Examples:
      | campo         |
      | nome          |
      | email         |
      | password      |
      | administrador |

  Scenario: No se puede registrar un usuario con un email invalido
    * set usuario.email = 'correo-invalido'

    Given path 'usuarios'
    And request usuario
    When method post
    Then status 400
    And match response.email == 'email deve ser um email válido'

  Scenario: No se puede registrar un usuario con un valor invalido en administrador
    * set usuario.administrador = 'si'

    Given path 'usuarios'
    And request usuario
    When method post
    Then status 400
    And match response.administrador == "administrador deve ser 'true' ou 'false'"
