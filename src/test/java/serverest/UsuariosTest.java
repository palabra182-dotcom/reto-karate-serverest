package serverest;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.DynamicNode;

public class UsuariosTest {

    @Karate.Test
    public Iterable<DynamicNode> listarUsuarios() {
        return Karate.run("classpath:serverest/usuarios/listar-usuarios.feature");
    }

    @Karate.Test
    public Iterable<DynamicNode> registrarUsuario() {
        return Karate.run("classpath:serverest/usuarios/registrar-usuario.feature");
    }

    @Karate.Test
    public Iterable<DynamicNode> buscarUsuario() {
        return Karate.run("classpath:serverest/usuarios/buscar-usuario.feature");
    }

    @Karate.Test
    public Iterable<DynamicNode> actualizarUsuario() {
        return Karate.run("classpath:serverest/usuarios/actualizar-usuario.feature");
    }

    @Karate.Test
    public Iterable<DynamicNode> eliminarUsuario() {
        return Karate.run("classpath:serverest/usuarios/eliminar-usuario.feature");
    }
}
