import { List, Datagrid, TextField, NumberField, BooleanField } from 'react-admin';

const espaciosList = () => (
<List perPage={10}>
        <Datagrid>
            <TextField source="name" />
            <NumberField source="quantity" />
            <BooleanField source="available" />
        </Datagrid>
    </List>
);

export default espaciosList;