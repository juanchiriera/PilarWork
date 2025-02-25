import { Show, SimpleShowLayout, TextField, ArrayField, EmailField, DateField, ReferenceField, Datagrid } from 'react-admin';

const reservasShow = (props: any) => (
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="personas" label="Personas" />
            <DateField source="fechaInicio" label="Inicio reserva" />
            <DateField source="fechaFin" label="Fin reserva" />
            <ArrayField source="elementos" label="Elementos">
                <Datagrid bulkActionButtons={false} rowClick={false}>
                    <TextField source="name" />
                    <TextField source="quantity" />
                    <TextField source="available" />
                </Datagrid>
            </ArrayField>
            <ReferenceField source="cliente" reference="clientes" label="Cliente" link={false}>
                <SimpleShowLayout>
                    <TextField source="name" label="Nombre" />
                    <TextField source="surname" label="Apellido" />
                    <EmailField source="mail" label="Correo Electrónico" />
                    <TextField source="phone" label="Teléfono" />
                </SimpleShowLayout>
            </ReferenceField>
        </SimpleShowLayout>
    </Show>
);

export default reservasShow;