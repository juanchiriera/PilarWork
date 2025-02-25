import { Show, SimpleShowLayout, TextField, ArrayField, Datagrid, NumberField, ReferenceField } from 'react-admin';

const precioShow = (props: any) => (
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="medida" label="Medida" />
            <NumberField source="valor" label="Valor" />
            <ArrayField source="espacios" label="Espacio">
                <Datagrid bulkActionButtons={false} rowClick={false}>
                    <TextField source="name" label="Nombre" />
                    <TextField source="available" label="Disponible" />
                </Datagrid>
            </ArrayField>
        </SimpleShowLayout>
    </Show>
);

export default precioShow;