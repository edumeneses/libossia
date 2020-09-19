package io.ossia;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import java.util.Optional;
import java.util.OptionalInt;
import java.util.OptionalDouble;

public class Node
{
  Node(Pointer p)
  {
    impl = p;
  }

  public Node createNode(String s)
  {
    return new Node(Ossia.INSTANCE.ossia_node_create(impl, s));
  }

  public Node findNode(String s)
  {
    Pointer p = Ossia.INSTANCE.ossia_node_find(impl, s);
    if(p != null)
      return new Node(p);
    return null;
  }

  public int childCount()
  {
    return Ossia.INSTANCE.ossia_node_child_size(impl);
  }

  public Node getChild(int i)
  {
    return new Node(Ossia.INSTANCE.ossia_node_get_child(impl, i));
  }

  public Parameter createParameter(int t)
  {
    return new Parameter(Ossia.INSTANCE.ossia_node_create_parameter(impl, t));
  }

  public Parameter create(String name, String type)
  {
    return new Parameter(Ossia.INSTANCE.ossia_create_parameter(impl, name, type));
  }

  public Parameter getParameter()
  {
    Pointer p = Ossia.INSTANCE.ossia_node_get_parameter(impl);
    if(p != null)
      return new Parameter(p);
    return null;
  }

  public String getDescription()
  {
    return Ossia.INSTANCE.ossia_node_get_description(impl);
  }
  public void setDescription(String u)
  {
    Ossia.INSTANCE.ossia_node_set_description(impl, u);
  }

  public String getExtendedType()
  {
    return Ossia.INSTANCE.ossia_node_get_extended_type(impl);
  }
  public void setExtendedType(String u)
  {
    Ossia.INSTANCE.ossia_node_set_extended_type(impl, u);
  }

  // Hidden
  public boolean getHidden()
  {
    return Ossia.INSTANCE.ossia_node_get_hidden(impl) == 0 ? false : true;
  }
  public void setHidden(boolean u)
  {
    Ossia.INSTANCE.ossia_node_set_hidden(impl, u ? 1 : 0);
  }

  // Refresh rate
  public OptionalInt getRefreshRate()
  {
    IntByReference ref = new IntByReference(0);
    int res = Ossia.INSTANCE.ossia_node_get_refresh_rate(impl, ref);
    if(ref.getValue() != 0)
    {
      return OptionalInt.of(res);
    }
    else
    {
      return OptionalInt.empty();
    }
  }

  public void setRefreshRate(OptionalInt u)
  {
    if(u.isPresent())
      Ossia.INSTANCE.ossia_node_set_refresh_rate(impl, u.getAsInt());
    else
      Ossia.INSTANCE.ossia_node_unset_refresh_rate(impl);
  }

  public void setRefreshRate(int u)
  {
    Ossia.INSTANCE.ossia_node_set_refresh_rate(impl, u);
  }

  public void unsetRefreshRate()
  {
    Ossia.INSTANCE.ossia_node_unset_refresh_rate(impl);
  }
  
  // Priority
  public OptionalDouble getPriority()
  {
    IntByReference ref = new IntByReference(0);
    float res = Ossia.INSTANCE.ossia_node_get_priority(impl, ref);
    if(ref.getValue() != 0)
    {
      return OptionalDouble.of(res);
    }
    else
    {
      return OptionalDouble.empty();
    }
  }
  public void setPriority(OptionalDouble u)
  {
    if(u.isPresent())
      Ossia.INSTANCE.ossia_node_set_priority(impl, (float)u.getAsDouble());
    else
      Ossia.INSTANCE.ossia_node_unset_priority(impl);
  }
  public void setPriority(double u)
  {
    Ossia.INSTANCE.ossia_node_set_priority(impl, (float)u);
  }
  public void unsetPriority()
  {
    Ossia.INSTANCE.ossia_node_unset_priority(impl);
  }

  // Step size
  public OptionalDouble getValueStepSize()
  {
    IntByReference ref = new IntByReference(0);
    double res = Ossia.INSTANCE.ossia_node_get_value_step_size(impl, ref);
    if(ref.getValue() != 0)
    {
      return OptionalDouble.of(res);
    }
    else
    {
      return OptionalDouble.empty();
    }
  }
  public void setValueStepSize(OptionalDouble u)
  {
    if(u.isPresent())
      Ossia.INSTANCE.ossia_node_set_value_step_size(impl, u.getAsDouble());
    else
      Ossia.INSTANCE.ossia_node_unset_value_step_size(impl);
  }
  public void setValueStepSize(double u)
  {
    Ossia.INSTANCE.ossia_node_set_value_step_size(impl, u);
  }
  public void unsetValueStepSize()
  {
    Ossia.INSTANCE.ossia_node_unset_value_step_size(impl);
  }

  // Instance bounds
  public Optional<InstanceBounds> getInstanceBounds()
  {
    IntByReference min = new IntByReference(0);
    IntByReference max = new IntByReference(0);
    IntByReference ok = new IntByReference(0);
    Ossia.INSTANCE.ossia_node_get_instance_bounds(impl, min, max, ok);
    if(ok.getValue() != 0)
    {
      return Optional.of(new InstanceBounds(min.getValue(), max.getValue()));
    }
    else
    {
      return Optional.empty();
    }
  }
  
  public void setInstanceBounds(Optional<InstanceBounds> u)
  {
    if(u.isPresent())
    {
      InstanceBounds inst = u.get();
      Ossia.INSTANCE.ossia_node_set_instance_bounds(impl, inst.min, inst.max);
    }
    else
    {
      Ossia.INSTANCE.ossia_node_unset_instance_bounds(impl);
    }
  }
  
  public void setInstanceBounds(int min, int max)
  {
    Ossia.INSTANCE.ossia_node_set_instance_bounds(impl, min, max);
  }
  public void unsetInstanceBounds()
  {
    Ossia.INSTANCE.ossia_node_unset_instance_bounds(impl);
  }

  // Default value
  public Optional<Value> getDefaultValue()
  {
    Pointer p = Ossia.INSTANCE.ossia_node_get_default_value(impl);
    if(p != Pointer.NULL)
    {
      return Optional.empty();
    }
    else
    {
      return Optional.of(new Value(p));  
    }
  }
  
  public void setDefaultValue(Value u)
  {
    Ossia.INSTANCE.ossia_node_set_default_value(impl, u.impl);
  }

  Pointer impl;
}
