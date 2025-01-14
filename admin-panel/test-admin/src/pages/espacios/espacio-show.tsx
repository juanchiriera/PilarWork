import { Show, SimpleShowLayout, TextField, ArrayField, Datagrid} from 'react-admin';

const espaciosShow = (props: any) => ( 
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="name" label="Nombre" />
            <TextField source="quantity" label="Quantity" />
            <TextField source="available" label="Disponible" />
            <ArrayField source="elementos" label="Elementos">
                <Datagrid>
                    <TextField source="name" label="Nombre"/>
                    <TextField source="quantity"/>
                    <TextField source="available" label="Disponible"/>
                </Datagrid>
            </ArrayField>
        </SimpleShowLayout>
    </Show>
);

export default espaciosShow;