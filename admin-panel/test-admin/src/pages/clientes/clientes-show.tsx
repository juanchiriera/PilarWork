import { Show, SimpleShowLayout, TextField, EmailField } from 'react-admin';

const ClientesShow = (props: any) => (
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="name" label="Nombre" />
            <TextField source="surname" label="Apellido" />
            <EmailField source="mail" label="Correo Electrónico" />
            <TextField source="phone" label="Teléfono" />
        </SimpleShowLayout>
    </Show>
);

export default ClientesShow;