---

---
{% include subindex-html-start.html name="{{album_name}}" css_file="photo_gallery.css" description="{{album_description}}" thumbnail="http://armcknight.com/photos/{{album_id}}/img/{{cover_image_thumbnail_url}}" %}
                
<!-- cover image -->
{% assign cover_photo = site.photos | where: 'album', '{{album_id}}' | where:'image_url', '{{cover_image_url}}' %}

<center>
    <table>
      <tr>
        <td class="thumbnail">
          <a href="img/{{ cover_photo[0].image_url }}"><img src="img/{{ cover_photo[0].thumbnail_url }}" height="100px" alt="{{ cover_photo[0].description }}" /></a>
        </td>
      </tr>
      <tr>
        <td class="description">
          {{ cover_photo[0].description }}
        </td>
      </tr>
    </table>
</center>

<!-- album images -->
{% assign photo_index = 1 %}
{% assign photos_to_iterate = site.photos | where: 'album', '{{album_id}}' | sort: 'index' %}
{% for photo in photos_to_iterate %}
  {% if photo.image_url != '{{cover_image_url}}' %}
    <table class="gallery-item" width="{{ photo.thumbnail_width }}">
      <tr>
        <td class="thumbnail">
          {% if photo_index == 1 %}
            <a href="slideshow/"><img src="img/{{ photo.thumbnail_url }}" height="100px" alt="{{ photo.description }}" /></a>
          {% else %}
            <a href="slideshow/{{ photo_index }}"><img src="img/{{ photo.thumbnail_url }}" height="100px" alt="{{ photo.description }}" /></a>
          {% endif %}
        </td>
      </tr>
      <tr>
        <td class="description">
          {{ photo.description }}
        </td>
      </tr>
    </table>
  {% endif %}
  {% assign photo_index = photo_index | plus: 1 %}
{% endfor %}
              
{% include subindex-html-end.html %}