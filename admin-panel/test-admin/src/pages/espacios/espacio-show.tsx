import { Show, SimpleShowLayout, TextField, NumberField, BooleanField, ArrayField, Datagrid} from 'react-admin';

const EspaciosShow = (props: any) => (
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="name" />
            <NumberField source="quantity" />
            <BooleanField source="available" />
            <ArrayField source="elementos">
                <Datagrid>
                    <TextField source="name" />
                    <NumberField source="quantity" />
                    <BooleanField source="available" />
                </Datagrid>
            </ArrayField>
        </SimpleShowLayout>
    </Show>
);

export default EspaciosShow;