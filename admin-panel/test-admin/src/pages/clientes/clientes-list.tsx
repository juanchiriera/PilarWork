import { List, Datagrid, TextField, EmailField } from 'react-admin';

const clientesList = () => (
<List perPage={10}>
        <Datagrid>
            <TextField source="name" label="Nombre" />
            <TextField source="surname" label="Apellido" />
            <EmailField source="mail" label="Correo Electrónico" />
            <TextField source="phone" label="Teléfono" />
        </Datagrid>
    </List>
);

export default clientesList;