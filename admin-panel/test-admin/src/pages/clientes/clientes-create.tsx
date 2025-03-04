import { Create, SimpleForm, TextInput} from "react-admin";

const clienteCreate = () => (
    <Create>
        <SimpleForm>
            <TextInput source="name" label="Nombre" />
            <TextInput source="surname" label="Apellido" />
            <TextInput source="mail" label="Correo Electrónico" />
            <TextInput source="phone" label="Teléfono" />
        </SimpleForm>
    </Create>
);

export default clienteCreate;