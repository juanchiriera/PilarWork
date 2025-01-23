import { Show, SimpleShowLayout, TextField, ArrayField, Datagrid, List, ListGuesser, SimpleList} from 'react-admin';

const espaciosShow = (props: any) => ( 
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="name" label="Nombre" />
            <TextField source="quantity" label="Quantity" />
            <TextField source="available" label="Disponible" />
            <ArrayField source="elementos" label="Elementos">
                <Datagrid bulkActionButtons={false} rowClick={false}>
                    <TextField source="name" />
                    <TextField source="quantity" />
                    <TextField source="available" />
                </Datagrid>
            </ArrayField>
        </SimpleShowLayout>
    </Show>
);

export default espaciosShow;