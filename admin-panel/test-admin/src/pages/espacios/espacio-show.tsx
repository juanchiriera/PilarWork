import { Show, SimpleShowLayout, TextField, ArrayField, Datagrid } from 'react-admin';

const EspaciosShow = () => (
    <Show>
        <SimpleShowLayout>
            <TextField source="name" />
            <TextField source="quantity" />
            <TextField source="available" />
            <ArrayField source="elementos">
                <Datagrid>
                    <TextField source="name" />
                    <TextField source="quantity" />
                    <TextField source="available" />
                </Datagrid>
            </ArrayField>
        </SimpleShowLayout>
    </Show>
);

export default EspaciosShow;