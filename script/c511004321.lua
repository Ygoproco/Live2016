--ローガーディアン a.k.a Skull Skull Servant (DOR)
function c511004321.initial_effect(c)
	--change name to Skull Servant -->32274490
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(32274490)
	c:RegisterEffect(e1)
	--flip effect & atkupdate of all skull servant currently on the field by 300 pts
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511004321,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e2:SetOperation(c511004321.operation)
	c:RegisterEffect(e2)
end
function c511004321.atktg(e,c)
	return c:GetFieldID()<=e:GetLabel() and c:IsCode(32274490)
end
function c511004321.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
		local mg,fid=g:GetMaxGroup(Card.GetFieldID)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c511004321.atktg)
		e1:SetValue(300)
		e1:SetLabel(fid)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
	
	
--Scripter Notes:
--When this card is flipped face-up, all Skull Servants are increased by 300 points.
--The flip eff only works for original skull servants, this Anime Atk points wont update. So to overcome this problem, i've decided to adding Harpie Harpist eff (56585883) to Skull Servant DOR
