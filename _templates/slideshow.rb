---
paginate:
  collection: photos
  category: {{album_id}}
  per_page: 1
  limit: false
  permalink: /:num/
---
{% if paginator.page == 1 %}
  {% include subindex-html-start.html name="{{album_name}}" css_file="slideshow_slide.css" description="{{album_description}}" %}
{% else %}
  {% include subindex-html-start.html name="{{album_name}}" css_file="slideshow_slide.css" description="{{album_description}}" back_url="../.." %}
{% endif %}

{% for photo in paginator.photos %}
  <center>
    <table>
      <tr>
        <td class="image">
          <a href="/photos/{{album_id}}/img/{{ photo.image_url }}"><img src="/photos/{{album_id}}/img/{{ photo.image_url }}" style="max-height: 80%; max-width: 80%;" /></a>
        </td>
      </tr>
      <tr>
        <td class="description">
          ({{ paginator.page }}/{{ paginator.total_photos }}): {{ photo.description }}
        </td>
      </tr>
      <tr>
        <td>
          <center>
            {% if paginator.previous_page != nil %}
              {% if paginator.previous_page == 1 %}
                <a href="../">Previous</a>
              {% else %}
                <a href="../{{ paginator.previous_page }}">Previous</a>
              {% endif %}
            {% endif %}
            {% if paginator.next_page != nil %}
              {% if paginator.next_page == 2 %}
                <a href="{{ paginator.next_page }}">Next</a>
              {% else %}
                <a href="../{{ paginator.next_page }}">Next</a>
              {% endif %}
            {% endif %}
          </center>
        </td>
      </tr>
    </table>
  </center>
{% endfor %}
              
{% include subindex-html-end.html %}