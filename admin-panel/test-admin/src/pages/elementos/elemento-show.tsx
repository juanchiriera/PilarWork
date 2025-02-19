import { Show, SimpleShowLayout, TextField} from 'react-admin';

const elementoShow = () => ( 
    <Show>
        <SimpleShowLayout>
            <TextField source="name" label="Nombre" />
            <TextField source="quantity" label="Quantity" />
            <TextField source="available" label="Disponible" />
        </SimpleShowLayout>
    </Show>
);

export default elementoShow;