--Parasite Queen
function c511009344.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,511002961,c511009344.ffilter,1,true,true)
	-- atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c511009344.val)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c511009344.atktg)
	e2:SetValue(c511009344.atkval)
	c:RegisterEffect(e2)
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80344569,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511009344.condition)
	e1:SetOperation(c511009344.operation)
	c:RegisterEffect(e1)
end

function c511009344.ffilter(c)
	return c:IsType(TYPE_FUSION)
end

function c511009344.val(e,c)
	return (Duel.GetMatchingGroupCount(c511009344.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())+Duel.GetMatchingGroupCount(c511009344.filter2,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()))*300
end
function c511009344.filter(c)
	return c:IsFaceup() and c:IsCode(511002961)
end
function c511009344.filter2(c)
	return c:IsFaceup() and c:IsCode(511002961) and c:IsHasEffect(511009347)
end
function c511009344.atktg(e,c)
	return not c:IsCode(511009344)
end
function c511009344.atkval(e,c)
	return c:GetEquipGroup():FilterCount(Card.IsCode,nil,511002961)*-800
end
function c511009344.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,511002961)
end


function c511009344.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local eqc=e:GetHandler():GetEquipGroup():Filter(Card.IsCode,nil,511002961):GetFirst()
	if eqc and tc:IsFaceup() then
		if not Duel.Equip(tp,eqc,tc,false) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c511009344.eqlimit)
			e1:SetLabelObject(tc)
			eqc:RegisterEffect(e1)
	end
end
function c511009344.eqlimit(e,c)
	return e:GetLabelObject()==c
end
