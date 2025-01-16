import { Edit, SimpleForm, TextInput } from 'react-admin';

const clienteEdit = () => (
    <Edit>
        <SimpleForm>
            <TextInput source="name" label="Nombre" />
            <TextInput source="surname" label="Apellido" />
            <TextInput source="mail" label="Correo Electrónico" />
            <TextInput source="phone" label="Teléfono" />
        </SimpleForm>
    </Edit>
);

export default clienteEdit;